#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>

constexpr char SOCKET_PATH[] = "/tmp/orchid_bridge_socket";
constexpr char PASSWORD[] = "orchidadmin";

int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    std::cerr << "Usage: " << argv[0] << " <data>" << std::endl;
    return -1;
  }

  int clientSocket;
  struct sockaddr_un serverAddr;

  // Create socket
  clientSocket = socket(AF_UNIX, SOCK_STREAM, 0);
  if (clientSocket < 0)
  {
    perror("Error creating socket");
    return -1;
  }

  // Set up server address
  memset(&serverAddr, 0, sizeof(serverAddr));
  serverAddr.sun_family = AF_UNIX;
  strncpy(serverAddr.sun_path, SOCKET_PATH, sizeof(serverAddr.sun_path) - 1);

  // Connect to the server
  if (connect(clientSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) < 0)
  {
    perror("Error connecting to server");
    return -1;
  }

  // Send text data from command-line parameter
  const char *textData = argv[1];
  ssize_t bytesSent = send(clientSocket, textData, strlen(textData), 0);
  if (bytesSent < 0)
  {
    perror("Error sending data");
    return -1;
  }

  // Close socket
  close(clientSocket);

  return 0;
}
