class RevenuesController < ApplicationController

  def index
    @orders = Order.current_week_revenue(current_user)

    @this_week_revenue = @orders.map {|o| {o.updated_at.strftime("%Y-%m-%d") => o.total} }
                                .inject({}) {|a,b| a.merge(b){|_,x,y| x + y}}

    @this_week_revenue = Date.today().all_week.map{ |date| [date.strftime("%a"), @this_week_revenue[date.strftime("%Y-%m-%d")] || 0 ] }

  end

end
