# Cloudfile

Cloudfile is an attempt to create a unified API for working with files on
different storage devices.

This should allow developers to use familiar APIs while minimizing the number of
breaking changes that occur when data is migrated from one storage medium to
another.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloudfile` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:cloudfile, "~> 0.1.0"}]
end
```


## Usage

### Google Cloud Storage

Using Cloudfile is easy. Here is an example using Google Cloud Storage:

#### Write

```elixir
Cloudfile.write("gcs://my-bucket/file.txt", "Testing, testing...")
:ok
```

#### Read

```elixir
Cloudfile.read!("gcs://my-bucket/file.txt")
"Testing, testing..."
```

#### Remove
```elixir
Cloudfile.rm("gcs://my-bucket/file.txt")
:ok
```

### Amazon S3
If your team decides to switch to Amazon's S3 storage, the code becomes:

#### Write

```elixir
Cloudfile.write("s3://my-bucket/file.txt", "Testing, testing...")
:ok
```

#### Read

```elixir
Cloudfile.read!("s3://my-bucket/file.txt")
"Testing, testing..."
```

#### Remove
```elixir
Cloudfile.rm("s3://my-bucket/file.txt")
:ok
```

Simple!


## Roadmap

 - [x] local storage
 - [x] HTTP & HTTPS
 - [x] Google Cloud Storage
 - [ ] Amazon S3
 - [ ] Box
 - [ ] FTP & SFTP
