#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>

constexpr char SOCKET_PATH[] = "/tmp/orchid_bridge_socket";
constexpr char PASSWORD[] = "orchidadmin";

int main()
{
  int serverSocket, clientSocket;
  struct sockaddr_un serverAddr, clientAddr;
  socklen_t clientLen = sizeof(clientAddr);

  // Create socket
  serverSocket = socket(AF_UNIX, SOCK_STREAM, 0);
  if (serverSocket < 0)
  {
    perror("Error creating socket");
    return -1;
  }

  // Set up server address
  memset(&serverAddr, 0, sizeof(serverAddr));
  serverAddr.sun_family = AF_UNIX;
  strncpy(serverAddr.sun_path, SOCKET_PATH, sizeof(serverAddr.sun_path) - 1);

  // Bind socket
  if (bind(serverSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) < 0)
  {
    perror("Error binding socket");
    return -1;
  }

  // Listen for incoming connections
  listen(serverSocket, 1);

  // Accept a connection
  clientSocket = accept(serverSocket, (struct sockaddr *)&clientAddr, &clientLen);
  if (clientSocket < 0)
  {
    perror("Error accepting connection");
    return -1;
  }

  // Receive text data
  char buffer[1024];
  ssize_t bytesRead = recv(clientSocket, buffer, sizeof(buffer) - 1, 0);
  if (bytesRead < 0)
  {
    perror("Error receiving data");
    return -1;
  }

  // Null-terminate the received data
  buffer[bytesRead] = '\0';

  // Check password (implement your password check logic here)

  // Print received text data
  std::cout << buffer << std::endl;

  // Close sockets
  close(clientSocket);
  close(serverSocket);

  // Remove the socket file
  unlink(SOCKET_PATH);

  return 0;
}
