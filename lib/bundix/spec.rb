# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  class Spec
    TYPE = T.type_alias do
      {
        'platforms' => T::Array[T_PLATFORM_SPEC],
        'groups' => T::Array[String],
        'version' => String,
        'source' => Source::TYPE,
      }
    end

    module Source
      TYPE = T.type_alias { T.any(PATH_TYPE, GEM_TYPE, GIT_TYPE) }

      PATH_TYPE = T.type_alias { { 'type' => String, 'path' => String } }

      GEM_TYPE = T.type_alias do
        { 'type' => String, 'remotes' => T::Array[String], 'sha256' => String }
      end

      GIT_TYPE = T.type_alias do
        {
          'type' => String,
          'sha256' => String,
          'url' => String,
          'rev' => String,
          'fetchSubmodules' => T::Boolean,
        }
      end
    end
  end
end
