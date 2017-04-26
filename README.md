# CloudFile

CloudFile is an attempt to create a unified API for working with files on
different storage devices.

This should allow developers to use familiar APIs while minimizing the number of
breaking changes that occur when data is migrated from one storage medium to
another.


## Available Drivers + Roadmap

 - [x] local storage
 - [x] HTTP & HTTPS
 - [x] Google Cloud Storage - [link](https://github.com/urbint/cloud_file_gcs)
 - [x] Amazon S3 - [link](https://github.com/urbint/cloud_file_s3)
 - [ ] Box
 - [ ] FTP & SFTP


## Feature Highlights

 - POSIX compliance: Drivers attempt to map errors to POSIX compliant filesystem errors


## Installation

** TODO: update snippet when published to `hex.pm`

```elixir
def deps do
  [{:cloud_file, git: "git@github.com:urbint/cloud_file.git"}]
end
```


## Usage

Let's say you're using Google Cloud Storage...

```elixir
CloudFile.write("gcs://my-bucket/file.txt", "Testing, testing...")
:ok

CloudFile.read!("gcs://my-bucket/file.txt")
"Testing, testing..."

CloudFile.rm!("gcs://my-bucket/file.txt")
:ok

CloudFile.read("gcs://my-bucket/file.txt")
{:error, :enoent}
```

...if you want to switch to Amazon's S3 storage the change is non-breaking.

```elixir
CloudFile.write("s3://my-bucket/file.txt", "Testing, testing...")
:ok

CloudFile.read!("s3://my-bucket/file.txt")
"Testing, testing..."

CloudFile.rm!("s3://my-bucket/file.txt")
:ok

CloudFile.read("s3://my-bucket/file.txt")
{:error, :enoent}
```


## Additional Usage

If you're feeling particularly adventurous, it's possible to configure different storage drivers for
each application environment.

### Testing and Dev config
```elixir
config :my_app,
  storage_driver: CloudFile.Drivers.Local

config :cloud_file,
  additional_drivers: []
```

### Production config
```elixir
@storage_driver CloudFile.Drivers.S3

config :my_app,
  storage_driver: @storage_driver

config :cloud_file,
  additional_drivers: [@storage_driver]
```

### Source Code
```elixir
@fs_prefix CloudFile.Utils.prefix_for(@storage_driver)

CloudFile.read("#{@fs_prefix}/path/to/file.txt")
```

Simple!
