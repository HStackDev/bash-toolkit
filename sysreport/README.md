# System Resource Reporter

A **Bash script** for Linux that collects CPU, memory, disk, and system information, and generates neatly formatted reports.

## Features

- CPU info: model, cores, usage, top processes  
- Memory info: RAM, swap, top memory processes  
- Disk usage: physical disks only (`/dev/*`)  
- System info: hostname, OS, kernel, uptime, users  
- Logs report generation with timestamps  

## Usage

```bash
chmod +x sysreport.sh
./sysreport.sh
```

- Reports are saved in `./reports`

- Logs are in `reporter.log`

