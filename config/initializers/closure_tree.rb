# FIXME: Mysql2 error using mysql 5.7.9 #190, https://github.com/mceachen/closure_tree/issues/190
module ClosureTree
  module HierarchyMaintenance
    def delete_hierarchy_references
      _ct.with_advisory_lock do
        results = _ct.connection.execute(<<-SQL.strip_heredoc)
          SELECT DISTINCT descendant_id
            FROM #{_ct.quoted_hierarchy_table_name}
            WHERE ancestor_id = #{_ct.quote(id)}
              OR descendant_id = #{_ct.quote(id)}
        SQL

        ids = Array.new
        results.each { |(descendant_id)| ids << descendant_id }

        _ct.connection.execute <<-SQL.strip_heredoc
          DELETE FROM #{_ct.quoted_hierarchy_table_name}
            WHERE descendant_id IN (#{ids.join(',')})
        SQL
      end
    end
  end
end
