# Docker image based on Alpine with Apache2 and PHP

Alpine image version: 3.10

Source: [https://github.com/mhaluska/docker-alpine-php](https://github.com/mhaluska/docker-alpine-php)

### Following environment variables can be used to customize this image

#### Change apache user UID and GID if defined:
- USER_UID=123
- USER_GID=321

#### MPM modification:
- MPM_START (StartServers, default 1)
- MPM_MINSPARE (MinSpareServers, default 1)
- MPM_MAXSPARE (MaxSpareServers, default 3)
- MPM_MAXREQ (MaxRequestWorkers, default 15)
- MPM_MAXCONN (MaxConnectionsPerChild, default 250)

#### PHP modification
- PHP_TZ (date.timezone, default Europe/Prague)
- PHP_POSTMAX (post_max_size, default 10M)
- PHP_UPLOADMAX (upload_max_filesize, default 8M)
- PHP_URLFOPEN (allow_url_fopen, default Off)
- PHP_DISABLE_USERINI (user_ini.filename, default 1 = disable this func)
- PHP_EXECMAX (max_execution_time, default 30)
- PHP_INPUTMAX (max_input_time, default 60)
- PHP_MEMLIMIT (memory_limit, default 128M)
