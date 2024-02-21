#ifndef ORCHID_PROTODB_H
#define ORCHID_PROTODB_H

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

void db_get(char *property)
{
  std::fstream db_file(DB_FILE_PATH, std::fstream::in | std::fstream::out | std::fstream::app);
  if (!db_file.is_open())
  {
    std::cerr << "Can't open file!" << std::endl;
  }

  std::map<std::string, std::string> properties = parse_db_file(db_file);

  auto it = properties.find(property);
  if (it != properties.end())
  {
    std::cout << it->second << std::endl;
  }
  else
  {
    std::cerr << "Property not found." << std::endl;
  }

  db_file.close();
  db_file.flush();
  db_file.seekg(0);
}

void db_set(char *property, char *data)
{
  std::fstream db_file(DB_FILE_PATH, std::fstream::in | std::fstream::out | std::fstream::app);
  if (!db_file.is_open())
  {
    std::cerr << "Can't open file!" << std::endl;
  }

  std::map<std::string, std::string> properties = parse_db_file(db_file);

  properties[property] = data;
  write_db_file(db_file, properties);

  db_file.close();
  db_file.flush();
  db_file.seekg(0);
}

#endif ORCHID_PROTODB_H
