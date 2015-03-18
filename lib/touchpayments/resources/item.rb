module TouchPayments::Resources
  class Item < BaseResource    
    
    states = [:active, :activeDue, :approved, :cancelled, :inCollection, :mixed, :new, :overdue, :paid, :paymentDelayed, :paymentRefused,:pending, :returnApprovalPending, :returnApprovalPendingAfterPayment, :returned, :returnedAfterPayment, :shipped, :unableToFullFill]
    
  end
end  