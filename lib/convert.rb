class Convert
  def process
    less_files.each do |name, file|
      file = open_git_file(file)
      file = convert(file)
      save_file(name, file)
    end
  end

private

  def less_files
    {
      '_reset'       => 'https://raw.github.com/twitter/bootstrap/master/lib/reset.less',
      '_variables'   => 'https://raw.github.com/twitter/bootstrap/master/lib/variables.less',
      '_scaffolding' => 'https://raw.github.com/twitter/bootstrap/master/lib/scaffolding.less',
      '_type'        => 'https://raw.github.com/twitter/bootstrap/1.3-wip/lib/type.less',
      '_forms'       => 'https://raw.github.com/twitter/bootstrap/master/lib/forms.less',
      '_tables'      => 'https://raw.github.com/twitter/bootstrap/master/lib/tables.less',
      '_patterns'    => 'https://raw.github.com/twitter/bootstrap/1.3-wip/lib/patterns.less'
    }
  end

  def convert(file)
    file = replace_vars(file)
    file = replace_fonts(file)
    file = replace_grads(file)
    file = replace_mixins(file)
    file = replace_includes(file)
    file = replace_spin(file)

    file
  end

  def open_git_file(file)
    URI.parse(file).read
  end

  def save_file(name, content)
    f = File.new("#{name}.scss", "w")
    f.write(content)
    f.close
  end

  def replace_vars(less)
    less.gsub(/@/, '$')
  end

  def replace_fonts(less)
    less.gsub(/#font \> \.([\w-]+)/, '@include \1')
  end

  def replace_grads(less)
    less.gsub(/#gradient \> \.([\w-]+)/, '@include gradient-\1')
  end

  def replace_mixins(less)
    less.gsub(/^\.([\w-]*)(\(.*\))([\s\{]+)$/, '@mixin \1\2\3')
  end

  def replace_includes(less)
    less.gsub(/\.([\w-]*)(\(.*\));?/, '@include \1\2;')
  end

  def replace_spin(less)
    less.gsub(/spin/, 'adjust-hue')
  end

end
