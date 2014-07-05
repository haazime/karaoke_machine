require 'spec_helper'

describe Key do
  describe "#transpose" do
    let(:key) { described_class.from_string(key_name) }

    subject do
      key.transpose(amount)
    end

    let(:key_name) { "C" }
    let(:amount) { 0 }

    it do
      is_expected.to be_instance_of(described_class)
    end

    context "when in key C" do
      let(:key_name) { "C" }

      [
        [0, "C"],
        [2, "D"],
        [6, "F#"],
        [11, "B"],
        [12, "C"],
        [19, "G"],
        [-7, "F"],
        [-12, "C"],
        [-13, "B"],
        [26, "D"],
        [24, "C"],
        [-24, "C"],
        [40, "E"],
      ]
        .each do |amount, expected|
        context "given #{amount} as amount" do
          let(:amount) { amount }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context "when in key D" do
      let(:key_name) { "D" }

      [
        [0, "D"],
        [2, "E"],
        [6, "G#"],
        [11, "C#"],
        [12, "D"],
        [19, "A"],
        [-7, "G"],
        [-12, "D"],
        [-13, "C#"],
        [26, "E"],
        [24, "D"],
        [-24, "D"],
        [40, "F#"],
      ]
        .each do |amount, expected|
        context "given #{amount} as amount" do
          let(:amount) { amount }

          it { is_expected.to eq(expected) }
        end
      end
    end
  end
end
