defmodule MovieMatchWeb.Components.ServiceCard do
  use MovieMatchWeb, :html

  attr :service, :map, required: true
  attr :selected, :boolean, default: false

  def service_card(assigns) do
    ~H"""
    <button
      phx-click="toggle_service"
      phx-value-service={@service.id}
      class={[
        "flex aspect-square flex-col items-center justify-center rounded-2xl border-2 transition",
        @selected &&
          "border-violet-500 bg-violet-500/10 shadow-lg shadow-violet-500/10",
        !@selected &&
          "border-slate-800 bg-slate-900 hover:border-slate-600"
      ]}
    >
      <img
        src={@service.logo}
        alt={@service.name}
        class={[
          "h-36 w-36 object-contain",
          @selected && "opacity-100",
          !@selected && "opacity-70"
        ]}
      />
    </button>
    """
  end
end