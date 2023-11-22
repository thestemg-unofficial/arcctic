defmodule ArccticWeb.RoomController do
  use ArccticWeb, :controller
 
  
  def show(conn, %{"id" => room_id}) do
    render(conn, :room, room_id: room_id)
  end

end
