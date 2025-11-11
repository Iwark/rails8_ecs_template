# Rails8 ECS template

It generates a rails project with:

- Ruby 3.4.5
- Rails 8.0
- Postgres 16
- Redis 7.2
- Cuprite Testing (chrome)
- [tailwind v4](https://tailwindcss.com/)
- [Sidekiq](https://github.com/mperham/sidekiq) with Redis
- [Sentry](https://sentry.io/)

It assumes you're using [vscode](https://code.visualstudio.com/) as your editor thus it adds `.vscode/settings.json` for you.

## How to make a rails project with this template

```
$ rails new project_name -m https://raw.githubusercontent.com/Iwark/rails8_ecs_template/main/app_template.rb
```

To use a local file as the template, run the following command:

```
$ rails new project_name -m ~/src/Iwark/rails8_ecs_template/app_template.rb
```

**Note:** When using a local file as the template, be sure to specify the correct path to `app_template.rb`.  
For example, if you cloned this repository to `~/src/Iwark/rails8_ecs_template`, the path should be `~/src/Iwark/rails8_ecs_template/app_template.rb`.  
The path must point directly to the template Ruby file, not to a directory.

### Sentry set-up

Add `sentry_dsn` to credentials if you want to use Sentry.

```
$ rails credentials:edit
```
