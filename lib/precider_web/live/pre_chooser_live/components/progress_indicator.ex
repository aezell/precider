defmodule PreciderWeb.PreChooserLive.Components.ProgressIndicator do
  use Phoenix.Component
  import PreciderWeb.CoreComponents

  attr :steps, :list, required: true
  attr :current_step, :integer, required: true
  attr :total_steps, :integer, required: true
  attr :show_results, :boolean, default: false

  def progress_indicator(assigns) do
    ~H"""
    <div class="mb-8">
      <div class="flex justify-center mb-4">
        <div class="flex items-center space-x-2">
          <%= for step <- @steps do %>
            <div class="flex items-center">
              <div class={[
                "w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium transition-all duration-200",
                if(step_completed?(step.id, @current_step, @show_results),
                  do: "bg-primary text-primary-content",
                  else:
                    if(step.id == @current_step,
                      do: "bg-primary/20 text-primary border-2 border-primary",
                      else: "bg-base-300 text-base-content/50"
                    )
                )
              ]}>
                <%= if step_completed?(step.id, @current_step, @show_results) do %>
                  <.icon name="hero-check" class="h-4 w-4" />
                <% else %>
                  {step.id}
                <% end %>
              </div>
              <%= if step.id < @total_steps do %>
                <div class={[
                  "w-12 h-0.5 mx-2 transition-all duration-200",
                  if(step_completed?(step.id, @current_step, @show_results),
                    do: "bg-primary",
                    else: "bg-base-300"
                  )
                ]}>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
      <div class="text-center">
        <span class="text-sm text-base-content/70">
          Step {@current_step} of {@total_steps}
        </span>
      </div>
    </div>
    """
  end

  defp step_completed?(step_id, current_step, show_results) do
    step_id < current_step || (step_id == current_step && show_results)
  end
end
