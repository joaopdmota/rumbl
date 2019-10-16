defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Videos
  alias Rumbl.Categories

  plug :load_categories when action in [:new, :create, :edit, :update]

  defp load_categories(conn, _) do
    categories = Categories.list_categories()
    assign(conn, :categories, categories)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
         [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    videos = Videos.list_videos(user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset = Videos.new_video(user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    case Videos.create_video(user, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Videos.get_video!(user, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Videos.get_video!(user, id)
    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Videos.get_video!(user, id)

    case Videos.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    user
    |> Videos.get_video!(id)
    |> Videos.delete_video

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end
end
