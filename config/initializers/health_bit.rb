HealthBit.configure do |c|
  # DEFAULT SETTINGS ARE SHOWN BELOW
  c.success_text = '%<count>d checks passed'
  c.headers = {
    'Content-Type' => 'text/plain;charset=utf-8',
    'Cache-Control' => 'private,max-age=0,must-revalidate,no-store'
  }
  c.success_code = 200
  c.fail_code = 500
  c.show_backtrace = false

  # We don't want health checks to pass if there are pending migrations.
  # Rails should throw by default if there are pending migrations, but adding 
  # explicitly just to be clear in case this gets copy/pasted to some other
  # env that doesn't do this by default for some reason.
  c.add('Needs Migrations') do
    !ActiveRecord::Migrator.needs_migration?
  end
end