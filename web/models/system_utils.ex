defmodule SystemUtils do
  require Logger

  def with_tmpdir!(f, prefix \\ "") do
    cwd = System.cwd!
    dirname = System.tmp_dir! <> "/" <> prefix <> SecureRandom.uuid
    File.mkdir_p!(dirname)
    File.cd!(dirname)
    f.(dirname)
    File.cd!(cwd)
    File.rm_rf!(dirname)
  end

  def cmd(string) do
    string = String.strip(string)
    Logger.debug("cmd: `#{string}`")

    [program | args] = String.split(string, " ")

    case System.cmd(program, args, stderr_to_stdout: true) do
      {result, 0}          -> {:ok, result}
      {result, _exit_code} -> {:error, result}
    end
  end

  def cmd!(string) do
    {:ok, result} = cmd(string)
    result
  end
end
