# Rails PostgreSQL Tasks

> Backup and restore your database with a simple task.

## Install/Usage

To get started first, `git clone` and copy the `*.rake` file to `lib/tasks` folder, or simply drag the lib folder to your project.

Set your database password in the credentials file (Rails 5.2+) using `EDITOR=nano rails credentials:edit` with a variable named `postgres_password` (Or change the rake file to match your needs).

Once you finish the "setup" you will be able to run the following commands:

``` bash
# To dump your database run:
rails db:dump

# To restore it run:
rails db:restore
```

Backup files will be dumped to `db/backup` folder.

Note: If you are using an older version of Rails, make sure to modify the credentials call in the task and map it to a variable under *secrets.yml*.

#### Configuring

Currently there's no command line support, all changes must be made editing the task itself.

## Contributing

If you wish to contribute please make a pull request or open an issue.

## License

Code released under the [MIT](LICENSE) license.
