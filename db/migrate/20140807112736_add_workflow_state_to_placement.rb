class AddWorkflowStateToPlacement < ActiveRecord::Migration
  def change
    add_column :placements, :workflow_state, :string
  end
end
