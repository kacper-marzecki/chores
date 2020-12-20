defmodule ChoresWeb.ActivityTagView do
  use ChoresWeb, :view
  alias ChoresWeb.ActivityTagView

  def render("index.json", %{activity_tags: activity_tags}) do
    %{data: render_many(activity_tags, ActivityTagView, "activity_tag.json")}
  end

  def render("show.json", %{activity_tag: activity_tag}) do
    %{data: render_one(activity_tag, ActivityTagView, "activity_tag.json")}
  end

  def render("activity_tag.json", %{activity_tag: activity_tag}) do
    %{id: activity_tag.id,
      name: activity_tag.name}
  end
end
