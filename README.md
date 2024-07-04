User Management Script (create_users.sh)

This script automates the creation of user accounts based on input from a text file. It reads a file containing usernames and associated groups, creates users with appropriate group memberships, sets up home directories, generates random passwords, and logs all actions to `/var/log/user_management.log`. Passwords are securely stored in `/var/secure/user_passwords.csv`.

Requirements

- Ubuntu environment
- Bash shell
- Root or sudo privileges
- Input file (`user_list.txt`) formatted as `username;group1,group2,...`

Usage

1. Clone Repository:
   ```bash
   git clone https://github.com/your-username/create_users.git
   cd create_users
   ```

2. Prepare Input File:
   Create a file `user_list.txt` in the format:
   ```plaintext
   light;sudo,dev,www-data
   idimma;sudo
   mayowa;dev,www-data
   ```
   Each line specifies a username followed by semicolon-separated group names.

3. Run Script:
   Execute the script with root or sudo privileges:
   ```bash
   sudo bash create_users.sh user_list.txt
   ```

4. View Logs and Passwords:
   - Logs are stored in `/var/log/user_management.log`.
   - Passwords are stored in `/var/secure/user_passwords.csv` (accessible to file owner only).

Files

- `create_users.sh`: Main bash script for user management.
- `README.md`: This file, providing an overview of the project.
- `user_list.txt`: Sample input file containing usernames and group memberships.

Notes

- Ensure the script is run in an Ubuntu environment due to system-specific paths and commands.
- Adjust file permissions and ownerships as necessary for your environment.

Author

- [Ekemini Thompson](https://github.com/ekemini-thompson)

Resources

- [HNG Internship](https://hng.tech/internship) - Learn more about the HNG Internship program.
- [HNG Premium](https://hng.tech/premium) - Additional information on HNG Premium services.