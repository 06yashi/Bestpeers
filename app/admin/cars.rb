ActiveAdmin.register Car do
  
  permit_params :name, :model, :price, :fuel_type, :seating_capacity  # Ensure all relevant fields are included

  
  index do
    selectable_column
    id_column
    column :name
    column :model
    column :price
    column :fuel_type
    column :seating_capacity
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :model
      f.input :price
      f.input :fuel_type
      f.input :seating_capacity
    end
    f.actions
  end


  filter :name
  filter :model
  filter :price  
  filter :fuel_type
  filter :seating_capacity
end
