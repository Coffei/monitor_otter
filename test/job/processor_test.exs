defmodule MonitorOtter.Job.ProcessorTest do
  use MonitorOtter.DataCase
  import Swoosh.TestAssertions
  alias MonitorOtter.DAO.Jobs
  alias MonitorOtter.DAO.Users
  alias MonitorOtter.Job.Processor
  alias MonitorOtterWeb.UserEmail

  test "email is sent if change is detected" do
    {:ok, job} =
      Jobs.create(%{
        name: "test job",
        enabled: true,
        url: "http://simple-abba.com",
        checker_type: "regex",
        checker_config: %{"regex" => "(bb)"},
        notification_email: "test@email.com",
        user: user(),
        last_state: ["aa"]
      })

    assert Processor.process(job) == :ok

    [job] = Jobs.get_all()
    assert_email_sent(email(job, ["aa"]))
  end

  test "job is updated if change is detected" do
    {:ok, job} =
      Jobs.create(%{
        name: "test job",
        enabled: true,
        url: "http://simple-abba.com",
        checker_type: "regex",
        checker_config: %{"regex" => "(bb)"},
        notification_email: "test@email.com",
        user: user(),
        last_state: ["aa"]
      })

    process_start = System.os_time(:second)
    assert Processor.process(job) == :ok

    [job] = Jobs.get_all()
    assert job.last_state == ["bb"]
    assert %DateTime{} = job.last_check_at
    assert process_start <= DateTime.to_unix(job.last_check_at, :second)
    assert job.last_check_change_at == job.last_check_at
  end

  test "email is not sent if change is not detected" do
    {:ok, job} =
      Jobs.create(%{
        name: "test job",
        enabled: true,
        url: "http://simple-abba.com",
        checker_type: "regex",
        checker_config: %{"regex" => "(bb)"},
        notification_email: "test@email.com",
        user: user(),
        last_state: ["bb"]
      })

    assert Processor.process(job) == :ok
    assert_no_email_sent()
  end

  test "job is updated if change is not detected" do
    {:ok, job} =
      Jobs.create(%{
        name: "test job",
        enabled: true,
        url: "http://simple-abba.com",
        checker_type: "regex",
        checker_config: %{"regex" => "(bb)"},
        notification_email: "test@email.com",
        user: user(),
        last_state: ["bb"]
      })

    process_start = System.os_time(:second)
    assert Processor.process(job) == :ok

    [job] = Jobs.get_all()
    assert job.last_state == ["bb"]
    assert %DateTime{} = job.last_check_at
    assert process_start <= DateTime.to_unix(job.last_check_at, :second)
    assert job.last_check_change_at == nil
  end

  defp user do
    {:ok, user} = Users.create(%{name: "test", email: "test@email.com", password: "password"})
    user
  end

  defp email(job, prev_state) do
    UserEmail.change_detected(job, prev_state)
  end
end
