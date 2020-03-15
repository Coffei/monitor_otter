defmodule MonitorOtter.DAO.JobsTest do
  use MonitorOtter.DataCase
  alias MonitorOtter.DAO.Jobs
  alias MonitorOtter.Models.Job

  test "job is created" do
    start = System.os_time(:second)

    assert {:ok, %Job{id: id}} =
             Jobs.create(%{
               name: "test job",
               enabled: false,
               url: "url_to_chec",
               checker_type: "regex",
               checker_config: %{"regex" => "aaa"},
               notification_email: "test@email.com"
             })

    assert is_integer(id)

    assert [
             %Job{
               id: ^id,
               name: "test job",
               enabled: false,
               url: "url_to_chec",
               checker_type: "regex",
               checker_config: %{"regex" => "aaa"},
               notification_email: "test@email.com",
               created_at: created_at = %DateTime{},
               changed_at: changed_at = %DateTime{}
             }
           ] = Jobs.get_all()

    created_at = DateTime.to_unix(created_at, :second)
    changed_at = DateTime.to_unix(changed_at, :second)

    assert start <= created_at
    assert start <= changed_at
    assert created_at == changed_at
  end

  test "job is updated" do
    start = System.os_time(:second)

    {:ok, %Job{id: id}} =
      Jobs.create(%{
        name: "test job",
        enabled: false,
        url: "url",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com"
      })

    before_update = System.os_time(:second)
    assert {:ok, %Job{id: ^id}} = Jobs.update(id, %{name: "new name", enabled: true})

    assert [
             %Job{
               id: ^id,
               name: "new name",
               enabled: true,
               url: "url",
               checker_type: "regex",
               checker_config: %{},
               notification_email: "test@email.com",
               created_at: created_at = %DateTime{},
               changed_at: changed_at = %DateTime{}
             }
           ] = Jobs.get_all()

    created_at = DateTime.to_unix(created_at, :second)
    changed_at = DateTime.to_unix(changed_at, :second)

    assert start <= created_at
    assert created_at <= changed_at
    assert before_update <= changed_at
  end

  test "non-existent job is not updated" do
    assert Jobs.update(123, %{name: "new_name"}) == {:error, :not_found}
  end

  test "job is marked as checked when no changed occurs" do
    start = System.os_time(:second)

    {:ok, %Job{id: new_id}} =
      Jobs.create(%{
        name: "clean",
        enabled: false,
        url: "url",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com"
      })

    {:ok, %Job{id: marked_id}} =
      Jobs.create(%{
        name: "updated",
        enabled: false,
        url: "url",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        last_check_at: DateTime.from_unix!(start - 10, :second),
        last_check_change_at: DateTime.from_unix!(start - 10, :second)
      })

    assert {:ok, %Job{}} = Jobs.mark_checked(new_id, false)
    assert {:ok, %Job{}} = Jobs.mark_checked(marked_id, false)
    jobs = Jobs.get_all()
    new = Enum.find(jobs, &(&1.id == new_id))
    marked = Enum.find(jobs, &(&1.id == marked_id))

    new_check_ts = DateTime.to_unix(new.last_check_at, :second)
    marked_check_ts = DateTime.to_unix(marked.last_check_at, :second)

    assert start <= new_check_ts
    assert start <= marked_check_ts
    assert new.last_check_change_at == nil
    assert marked.last_check_change_at == DateTime.from_unix!(start - 10, :second)
  end

  test "non-existent job is not marked as checked" do
    assert Jobs.mark_checked(123, false) == {:error, :not_found}
    assert Jobs.mark_checked(123, true) == {:error, :not_found}
  end

  test "job is marked as changed when last check results in change" do
    start = System.os_time(:second)

    {:ok, %Job{id: new_id}} =
      Jobs.create(%{
        name: "clean",
        enabled: false,
        url: "url",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com"
      })

    {:ok, %Job{id: marked_id}} =
      Jobs.create(%{
        name: "updated",
        enabled: false,
        url: "url",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        last_check_at: DateTime.from_unix!(start - 10, :second),
        last_check_change_at: DateTime.from_unix!(start - 10, :second)
      })

    assert {:ok, %Job{}} = Jobs.mark_checked(new_id, true)
    assert {:ok, %Job{}} = Jobs.mark_checked(marked_id, true)
    jobs = Jobs.get_all()
    new = Enum.find(jobs, &(&1.id == new_id))
    marked = Enum.find(jobs, &(&1.id == marked_id))

    new_change_ts = DateTime.to_unix(new.last_check_change_at, :second)
    marked_change_ts = DateTime.to_unix(marked.last_check_change_at, :second)

    assert start <= new_change_ts
    assert start <= marked_change_ts
  end

  test "job is deleted" do
    {:ok, %Job{id: id}} =
      Jobs.create(%{
        name: "clean",
        enabled: false,
        url: "url",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com"
      })

    assert {:ok, %Job{}} = Jobs.delete(id)
    assert Jobs.get_all() == []
  end

  test "job is not deleted if not found" do
    assert Jobs.delete(123) == {:error, :not_found}
  end

  test "last_state is properly saved" do
    assert {:ok, %Job{}} =
             Jobs.create(%{
               name: "test job",
               enabled: false,
               url: "url_to_chec",
               checker_type: "regex",
               checker_config: %{"regex" => "aaa"},
               notification_email: "test@email.com",
               last_state: %{some: {:custom, :erlang, :type}}
             })

    assert [
             %Job{
               last_state: %{some: {:custom, :erlang, :type}}
             }
           ] = Jobs.get_all()
  end
end
