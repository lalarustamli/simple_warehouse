# frozen_string_literal: true

module Regex
  INIT = /init (?<width>\d+) (?<length>\d+)/
  STORE = /store (?<x>\d+) (?<y>\d+) (?<width>\d+) (?<height>\d+) (?<pcode>\w+)/
  LOCATE = /locate (?<pcode>\w+)/
  REMOVE = /remove (?<x>\d+) (?<y>\d+)/
  VIEW = /view/
end