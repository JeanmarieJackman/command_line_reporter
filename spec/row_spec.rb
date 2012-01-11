require 'spec_helper'
require 'row'

describe Row do
  before :each do
    @cols = 10.times.map {|v| Column.new("test#{v}")}
  end

  describe '#add' do
    subject { Row.new }

    it 'adds columns' do
      subject.add(@cols[0])
      subject.columns.size.should == 1
      subject.columns[0].should == @cols[0]
      subject.add(@cols[1])
      subject.columns.should == @cols[0,2]
    end
  end

  describe '#to_s' do
    before :each do
      @cols = [
        Column.new('asdf'),
        Column.new('qwer', :align => 'center'),
        Column.new('zxcv', :align => 'right'),
        Column.new('x' * 25, :align => 'left', :width => 10),
        Column.new('x' * 25, :align => 'center', :width => 10),
        Column.new('x' * 35, :align => 'left', :width => 10),
      ]
    end

    before :all do
      @one_space = ' '
      @three_spaces = ' {3,3}'
      @six_spaces = ' {6,6}'
      @nine_spaces = ' {9,9}'
      @five_xs = 'x{5,5}'
      @ten_xs = 'x{10,10}'
    end

    context 'no border' do
      context 'no wrap' do
        it 'prints a single column' do
          subject.add(@cols[0])
          subject.should_receive(:puts).with(/^asdf#{@six_pieces}/)
          subject.to_s
        end
        it 'prints three columns' do
          subject.add(@cols[0])
          subject.add(@cols[1])
          subject.add(@cols[2])
          subject.should_receive(:puts).with(/^asdf#{@six_spaces}#{@one_space}#{@three_spaces}qwer#{@three_spaces}#{@one_space}#{@six_spaces}zxcv $/)
          subject.to_s
        end
      end

      context 'with wrapping' do
        it 'prints a single column' do
          subject.add(@cols[3])
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}$/)
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}$/)
          subject.should_receive(:puts).with(/^#{@five_xs}#{@six_spaces}$/)
          subject.to_s
        end

        it 'prints multiple columns of the same size' do
          subject.add(@cols[3])
          subject.add(@cols[4])
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}#{@ten_xs}#{@one_space}$/)
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}#{@ten_xs}#{@one_space}$/)
          subject.should_receive(:puts).with(/^#{@five_xs}#{@nine_spaces}#{@five_xs}#{@three_spaces}$/)
          subject.to_s
        end

        it 'prints multiple columns with different size' do
          subject.add(@cols[5])
          subject.add(@cols[3])
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}#{@ten_xs}#{@one_space}$/)
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}#{@ten_xs}#{@one_space}$/)
          subject.should_receive(:puts).with(/^#{@ten_xs}#{@one_space}#{@five_xs}#{@six_spaces}$/)
          subject.should_receive(:puts).with(/^#{@five_xs} {5,17}$/)
          subject.to_s
        end
      end
    end
  end
end
