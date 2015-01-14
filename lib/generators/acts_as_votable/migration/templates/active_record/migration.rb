class ActsAsVotableMigration < ActiveRecord::Migration
  def self.up
    table_name = ActsAsVotable.configuration.table_name

    create_table table_name do |t|

      t.references :votable, :polymorphic => true
      t.references :voter, :polymorphic => true

      t.boolean :vote_flag
      t.string :vote_scope
      t.integer :vote_weight

      t.timestamps
    end

    if ActiveRecord::VERSION::MAJOR < 4
      add_index table_name, [:votable_id, :votable_type]
      add_index table_name, [:voter_id, :voter_type]
    end

    add_index table_name, [:voter_id, :voter_type, :vote_scope]
    add_index table_name, [:votable_id, :votable_type, :vote_scope]
  end

  def self.down
    table_name = Settings.acts_as_votable.table_name rescue :votes
    drop_table :votes
  end
end
