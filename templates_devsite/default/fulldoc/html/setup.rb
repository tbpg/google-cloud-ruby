def init
  super

  sections.push :toc
end

def toc
  out = String.new("")
  out << "toc:\n"
  seen = {}
  Registry.all.each do |r|
    if toc_object(r)
      child_seen = print_child(out, "", r, seen)
      seen = seen.merge(child_seen)
    end
  end

  asset('_toc.yaml', out)
end

def print_child(out, indent, child, seen)
  if seen.key?(child.path)
    return seen
  end
  seen[child.path] = true
  out << indent << "- title: " << child.path << "\n"

  path = "/ruby/docs/reference/#{child.path}".gsub("::", "/")
  out << indent << "  path: #{path}" << "\n"
  if child.respond_to?(:children)
    children = child.children.select{|c| toc_object(c)}
    if children.length() > 0
      out << indent << "  section:\n"
      child.children.each do |child|
        if toc_object(child)
          child_seen = print_child(out, indent + "  ", child, seen)
          seen = seen.merge(child_seen)
        end
      end
    end
  end
  seen
end

def toc_object(obj)
  return obj.type != :method && obj.type != :constant
end

# @return [Array<String>] Stylesheet files that are additionally loaded for the
#   searchable full lists, e.g., Class List, Method List, File List
# @since 0.7.0
def stylesheets_full_list
  []
end

# @return [Array<String>] Javascript files that are additionally loaded for the
#   searchable full lists, e.g., Class List, Method List, File List.
# @since 0.7.0
def javascripts_full_list
  []
end