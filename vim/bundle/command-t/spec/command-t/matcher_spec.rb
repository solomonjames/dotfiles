# Copyright 2010-2014 Wincent Colaiuta. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

require 'spec_helper'
require 'ostruct'
require 'command-t/scanner'
require 'command-t/ext'

describe CommandT::Matcher do
  def matcher(*paths)
    scanner = OpenStruct.new(:paths => paths)
    CommandT::Matcher.new(scanner)
  end

  describe 'initialization' do
    it 'raises an ArgumentError if passed nil' do
      expect { CommandT::Matcher.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#sorted_matches_for' do
    def ordered_matches(paths, query)
      matcher(*paths).sorted_matches_for(query)
    end

    it 'raises an ArgumentError if passed nil' do
      expect { matcher.sorted_matches_for(nil) }.to raise_error(ArgumentError)
    end

    it 'returns empty array when source array empty' do
      matcher.sorted_matches_for('foo').should == []
      matcher.sorted_matches_for('').should == []
    end

    it 'returns empty array when no matches' do
      matcher = matcher(*%w[foo/bar foo/baz bing])
      matcher.sorted_matches_for('xyz').should == []
    end

    it 'returns matching paths' do
      matcher = matcher(*%w[foo/bar foo/baz bing])
      matches = matcher.sorted_matches_for('z')
      matches.map { |m| m.to_s }.should == ['foo/baz']
      matches = matcher.sorted_matches_for('bg')
      matches.map { |m| m.to_s }.should == ['bing']
    end

    it 'performs case-insensitive matching' do
      matches = matcher('Foo').sorted_matches_for('f')
      matches.map { |m| m.to_s }.should == ['Foo']
    end

    it 'considers the empty string to match everything' do
      matches = matcher('foo').sorted_matches_for('')
      matches.map { |m| m.to_s }.should == ['foo']
    end

    it 'does not consider mere substrings of the query string to be a match' do
      matcher('foo').sorted_matches_for('foo...').should == []
    end

    it 'prioritizes shorter paths over longer ones' do
      ordered_matches(%w[
        articles_controller_spec.rb
        article.rb
      ], 'art').should == %w[
        article.rb
        articles_controller_spec.rb
      ]
    end

    it 'prioritizes matches after "/"' do
      ordered_matches(%w[fooobar foo/bar], 'b').should == %w[foo/bar fooobar]

      # note that / beats _
      ordered_matches(%w[foo_bar foo/bar], 'b').should == %w[foo/bar foo_bar]

      # / also beats -
      ordered_matches(%w[foo-bar foo/bar], 'b').should == %w[foo/bar foo-bar]

      # and numbers
      ordered_matches(%w[foo9bar foo/bar], 'b').should == %w[foo/bar foo9bar]

      # and periods
      ordered_matches(%w[foo.bar foo/bar], 'b').should == %w[foo/bar foo.bar]

      # and spaces
      ordered_matches(['foo bar', 'foo/bar'], 'b').should == ['foo/bar', 'foo bar']
    end

    it 'prioritizes matches after "-"' do
      ordered_matches(%w[fooobar foo-bar], 'b').should == %w[foo-bar fooobar]

      # - also beats .
      ordered_matches(%w[foo.bar foo-bar], 'b').should == %w[foo-bar foo.bar]
    end

    it 'prioritizes matches after "_"' do
      ordered_matches(%w[fooobar foo_bar], 'b').should == %w[foo_bar fooobar]

      # _ also beats .
      ordered_matches(%w[foo.bar foo_bar], 'b').should == %w[foo_bar foo.bar]
    end

    it 'prioritizes matches after " "' do
      ordered_matches(['fooobar', 'foo bar'], 'b').should == ['foo bar', 'fooobar']

      # " " also beats .
      ordered_matches(['foo.bar', 'foo bar'], 'b').should == ['foo bar', 'foo.bar']
    end

    it 'prioritizes matches after numbers' do
      ordered_matches(%w[fooobar foo9bar], 'b').should == %w[foo9bar fooobar]

      # numbers also beat .
      ordered_matches(%w[foo.bar foo9bar], 'b').should == %w[foo9bar foo.bar]
    end

    it 'prioritizes matches after periods' do
      ordered_matches(%w[fooobar foo.bar], 'b').should == %w[foo.bar fooobar]
    end

    it 'prioritizes matching capitals following lowercase' do
      ordered_matches(%w[foobar fooBar], 'b').should == %w[fooBar foobar]
    end

    it 'prioritizes matches earlier in the string' do
      ordered_matches(%w[******b* **b*****], 'b').should == %w[**b***** ******b*]
    end

    it 'prioritizes matches closer to previous matches' do
      ordered_matches(%w[**b***c* **bc****], 'bc').should == %w[**bc**** **b***c*]
    end

    it 'scores alternative matches of same path differently' do
      # ie:
      # app/controllers/articles_controller.rb
      ordered_matches(%w[
        a**/****r******/**t*c***_*on*******.**
        ***/***********/art*****_con*******.**
      ], 'artcon').should == %w[
        ***/***********/art*****_con*******.**
        a**/****r******/**t*c***_*on*******.**
      ]
    end

    it 'provides intuitive results for "artcon" and "articles_controller"' do
      ordered_matches(%w[
        app/controllers/heartbeat_controller.rb
        app/controllers/articles_controller.rb
      ], 'artcon').should == %w[
        app/controllers/articles_controller.rb
        app/controllers/heartbeat_controller.rb
      ]
    end

    it 'provides intuitive results for "aca" and "a/c/articles_controller"' do
      ordered_matches(%w[
        app/controllers/heartbeat_controller.rb
        app/controllers/articles_controller.rb
      ], 'aca').should == %w[
        app/controllers/articles_controller.rb
        app/controllers/heartbeat_controller.rb
      ]
    end

    it 'provides intuitive results for "d" and "doc/command-t.txt"' do
      ordered_matches(%w[
        TODO
        doc/command-t.txt
      ], 'd').should == %w[
        doc/command-t.txt
        TODO
      ]
    end

    it 'provides intuitive results for "do" and "doc/command-t.txt"' do
      ordered_matches(%w[
        TODO
        doc/command-t.txt
      ], 'do').should == %w[
        doc/command-t.txt
        TODO
      ]
    end

    it "doesn't incorrectly accept repeats of the last-matched character" do
      # https://github.com/wincent/Command-T/issues/82
      matcher = matcher(*%w[ash/system/user/config.h])
      matcher.sorted_matches_for('usercc').should == []

      # simpler test case
      matcher = matcher(*%w[foobar])
      matcher.sorted_matches_for('fooooo').should == []

      # minimal repro
      matcher = matcher(*%w[ab])
      matcher.sorted_matches_for('aa').should == []
    end
  end
end
