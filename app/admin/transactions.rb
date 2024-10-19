# app/admin/transactions.rb
ActiveAdmin.register Transaction do
    permit_params :user_id, :stripe_charge_id, :amount, :currency, :status
  
    index do
      selectable_column
      id_column
      column :user
      column :stripe_charge_id
      column :amount
      column :currency
      column :status
      column :created_at
      column :updated_at
      actions
    end
  
    filter :user
    filter :stripe_charge_id
    filter :amount
    filter :currency
    filter :status
    filter :created_at
  
    form do |f|
      f.inputs do
        f.input :user
        f.input :stripe_charge_id
        f.input :amount
        f.input :currency
        f.input :status
      end
      f.actions
    end
  end
  