describe TableHelper do
  describe "#table_for" do
    it "generates a table for a hash" do
      hash = { a: "b", c: "d" }

      table = helper.table_for(hash)

      expect(table).to eql(
        '<table class="table key-value-table"><tr><td>a</td><td>b</td></tr><tr><td>c</td><td>d</td></tr></table>',
      )
    end

    it "generates a table-inside-a-table for a nested hash" do
      hash = { a: "b", c: { d: "e" } }

      table = helper.table_for(hash)

      expect(table).to include(
        '<table class="table key-value-table"><tr><td>d</td><td>e</td></tr></table>',
      )
    end

    it "generates a list for an array value" do
      hash = { a: %w[b c d] }

      table = helper.table_for(hash)

      expect(table).to include(
        "<ul><li>b</li><li>c</li><li>d</li></ul>",
      )
    end
  end
end
