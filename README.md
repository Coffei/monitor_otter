# Monitor Otter

<img src="logo.png" height="250px" alt="hand-drawn realistic otter image"/>

A small app to monitor web pages for you and notify you if a specified change occurs. You can
specify with regex what in the page is important to you.

## Running in dev

First check out `.env-sample`, rename it to `.env` and complete it with your SMTP settings. If you
don't want to use SMTP, you can modify `config/dev.exs` to use different mailer.

Right now you have to manually create a Job in the elixir console. Some level of configuration via
UI will come later. Currently jobs are monitored every hour.

You can run this in Google App Engine, see the enclosed `app.yaml.sample`.
