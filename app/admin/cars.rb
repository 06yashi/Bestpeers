ActiveAdmin.register Car do
  # Permit parameters for form submission
  permit_params :name, :model,  :price

  # Customize the index page table
  index do
    selectable_column
    id_column
    column :name
    column :model
    column :year
    column :price
    actions
  end

  # Customize the form for creating/editing a car
  form do |f|
    f.inputs do
      f.input :name
      f.input :model
      f.input :year
      f.input :price
    end
    f.actions
  end

  # Optional: Filters on the index page
  filter :name
  filter :model
  filter :year
  filter :price
end
