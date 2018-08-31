namespace :db do
  desc 'Dumps the database based on env'
  task dump: :environment do
    # Set the backup dir location
    backup_dir = Rails.root.join('db', 'backup')
    # Initialize variables
    full_path = nil
    cmd = nil

    # Set the database password if any
    db_password = "PGPASSWORD=#{Rails.application.credentials.postgres_password}"

    # Create the connection to the db and prepare the command
    with_config do |app, host, db, user|
      full_path = "#{backup_dir}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{db}.dump"
      cmd = "#{db_password} pg_dump -F c -v -O -U '#{user}' -h '#{host}' -d '#{db}' -f '#{full_path}'"
    end

    # Create the backup folder if it doesn't exist
    Dir.mkdir(backup_dir) unless File.exists?(backup_dir)

    # Run the dump command
    puts cmd
    system cmd
    puts "Dumped to file: #{full_path}"
  end

  desc 'Restores the database from a backup file'
  task restore: :environment do
    # Set the backup dir location
    backup_dir = Rails.root.join('db', 'backup')
    # Initialize variables
    file = nil
    cmd = nil

    # Set the database password if any
    db_password = "PGPASSWORD=#{Rails.application.credentials.postgres_password}"

    # Create the connection to the db and prepare the command
    with_config do |app, host, db, user|
      file = Dir.glob("#{backup_dir}/*.dump").max_by { |f| File.mtime(f) }
      cmd = "#{db_password} pg_restore -F c -v -c -U '#{user}' -h '#{host}' -d '#{db}' '#{file}'"
    end

    # If cmd is nil do nothing
    unless cmd.nil?
      # Create tables if needed
      Rake::Task["db:create"].invoke
      # Restore from a dump file
      puts cmd
      system cmd
      puts "Restored from file: #{file}"
    end
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username]
  end
end
