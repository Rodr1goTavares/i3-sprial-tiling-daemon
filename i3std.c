#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <fcntl.h>
#include <stdint.h>

#define I3_IPC_MAGIC "i3-ipc"
#define I3_IPC_MAGIC_LEN 6

#define I3_IPC_MESSAGE_TYPE_COMMAND 0
#define I3_IPC_MESSAGE_TYPE_SUBSCRIBE 2

int connect_i3_socket(const char *socket_path) {
    int sockfd;
    struct sockaddr_un addr;
    sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockfd == -1) { perror("socket"); exit(1); }
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path)-1);
    if (connect(sockfd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
        perror("connect"); exit(1);
    }
    return sockfd;
}

void send_i3_command(int sockfd, const char *command) {
    uint32_t len = strlen(command);
    char header[14] = {0};
    memcpy(header, I3_IPC_MAGIC, I3_IPC_MAGIC_LEN);
    memcpy(header + 6, &len, 4);
    uint32_t type = I3_IPC_MESSAGE_TYPE_COMMAND;
    memcpy(header + 10, &type, 4);

    write(sockfd, header, 14);
    write(sockfd, command, len);

    char reply_header[14];
    read(sockfd, reply_header, 14);
    uint32_t reply_len;
    memcpy(&reply_len, reply_header + 6, 4);
    char *reply = malloc(reply_len + 1);
    read(sockfd, reply, reply_len);
    reply[reply_len] = '\0';
    free(reply);
}

void subscribe_to_events(int sockfd) {
    const char *payload = "[\"window\"]";
    uint32_t len = strlen(payload);
    char header[14] = {0};
    memcpy(header, I3_IPC_MAGIC, I3_IPC_MAGIC_LEN);
    memcpy(header + 6, &len, 4);
    uint32_t type = I3_IPC_MESSAGE_TYPE_SUBSCRIBE;
    memcpy(header + 10, &type, 4);

    write(sockfd, header, 14);
    write(sockfd, payload, len);

    char reply_header[14];
    read(sockfd, reply_header, 14);
    uint32_t reply_len;
    memcpy(&reply_len, reply_header + 6, 4);
    char *reply = malloc(reply_len + 1);
    read(sockfd, reply, reply_len);
    reply[reply_len] = '\0';
    free(reply);
}

int main() {
  printf("Listening...\n");
  const char *socket_path = getenv("I3_SOCKET_PATH");
  if (!socket_path) {
    fprintf(stderr, "I3_SOCKET_PATH is not defined. Run 'export I3_SOCKET_PATH=$(i3 --get-socketpath)'\n");
    exit(1);
  }

  int sockfd = connect_i3_socket(socket_path);
  subscribe_to_events(sockfd);

  int state = 0;

  while (1) {
    char header[14];
    ssize_t n = read(sockfd, header, 14);
    if (n <= 0) continue;

    uint32_t payload_len;
    memcpy(&payload_len, header + 6, 4);
    char *payload = malloc(payload_len + 1);
    read(sockfd, payload, payload_len);
    payload[payload_len] = '\0';

    if (strstr(payload, "\"change\":\"new\"")) {
      int cmd_sock = connect_i3_socket(socket_path);
      const char *cmd = state == 0 ? "split v" : "split h";
      send_i3_command(cmd_sock, cmd);
      close(cmd_sock);
      state = !state;
    }

    free(payload);
  }

  close(sockfd);
  return 0;
}
