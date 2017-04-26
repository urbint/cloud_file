# CloudFile

CloudFile is an attempt to create a unified API for working with files on
different storage devices.

This should allow developers to use familiar APIs while minimizing the number of
breaking changes that occur when data is migrated from one storage medium to
another.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloud_file` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:cloud_file, "~> 0.1.0"}]
end
```


## Usage

### Google Cloud Storage

Using CloudFile is easy. Here is an example using Google Cloud Storage:

#### Write

```elixir
CloudFile.write("gcs://my-bucket/file.txt", "Testing, testing...")
:ok
```

#### Read

```elixir
CloudFile.read!("gcs://my-bucket/file.txt")
"Testing, testing..."
```

#### Remove
```elixir
CloudFile.rm("gcs://my-bucket/file.txt")
:ok
```

### Amazon S3
If your team decides to switch to Amazon's S3 storage, the code becomes:

#### Write

```elixir
CloudFile.write("s3://my-bucket/file.txt", "Testing, testing...")
:ok
```

#### Read

```elixir
CloudFile.read!("s3://my-bucket/file.txt")
"Testing, testing..."
```

#### Remove
```elixir
CloudFile.rm("s3://my-bucket/file.txt")
:ok
```

Simple!


## Roadmap

 - [x] local storage
 - [x] HTTP & HTTPS
 - [x] Google Cloud Storage - [link](https://github.com/urbint/cloud_file_gcs)
 - [x] Amazon S3 - [link](https://github.com/urbint/cloud_file_s3)
 - [ ] Box
 - [ ] FTP & SFTP
