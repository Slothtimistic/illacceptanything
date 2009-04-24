module Arel
  class Update < Compound
    attributes :relation, :assignments
    deriving :==

    def initialize(relation, assignments)
      @relation, @assignments = relation, assignments.bind(relation)
    end

    def to_sql(formatter = nil)
      [
        "UPDATE #{table_sql} SET",
        assignments.collect do |attribute, value|
          "#{engine.quote_column_name(attribute.name)} = #{attribute.format(value)}"
        end.join(",\n"),
        ("WHERE #{wheres.map(&:to_sql).join('\n\tAND ')}"  unless wheres.blank?  ),
        ("LIMIT #{taken}"                                      unless taken.blank?    )
      ].join("\n")
    end

    def call(connection = engine)
      connection.update(to_sql)
    end
  end
end
