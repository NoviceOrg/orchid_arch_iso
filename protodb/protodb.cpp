#include <iostream>
#include <fstream>
#include <sstream>
#include <map>

constexpr char DB_FILE_PATH[] = "/usr/orchid.protodb";

std::map<std::string, std::string> parse_db_file(std::fstream &file)
{
  std::map<std::string, std::string> properties;
  std::string line;

  while (std::getline(file, line))
  {
    std::istringstream iss(line);
    std::string key, value;

    if (std::getline(iss, key, '=') && std::getline(iss, value))
    {
      properties[key] = value;
    }
  }

  return properties;
}

void write_db_file(std::fstream &file, const std::map<std::string, std::string> &properties)
{
  file.close();
  file.open(DB_FILE_PATH, std::fstream::out | std::fstream::trunc);

  for (const auto &entry : properties)
  {
    file << entry.first << '=' << entry.second << '\n';
  }

  file.close();
  file.open(DB_FILE_PATH, std::fstream::in | std::fstream::out | std::fstream::app);
}

int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    std::cerr << "Usage: " << argv[0] << " {get|set} <property> [<data>]" << std::endl;
    return -1;
  }

  std::fstream db_file(DB_FILE_PATH, std::fstream::in | std::fstream::out | std::fstream::app);
  if (!db_file.is_open())
  {
    std::cerr << "Can't open file!" << std::endl;
    return -1;
  }

  std::map<std::string, std::string> properties = parse_db_file(db_file);

  if (std::string(argv[1]) == "get" && argc == 3)
  {
    auto it = properties.find(argv[2]);
    if (it != properties.end())
    {
      std::cout << it->second << std::endl;
    }
    else
    {
      std::cerr << "Property not found." << std::endl;
    }
  }
  else if (std::string(argv[1]) == "set" && argc >= 4)
  {
    properties[argv[2]] = argv[3];
    write_db_file(db_file, properties);
  }
  else
  {
    std::cerr << "Usage: " << argv[0] << " {get|set} <property> [<data>]" << std::endl;
  }

  db_file.close();
  db_file.flush();
  db_file.seekg(0);

  return 0;
}
