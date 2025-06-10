require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#formatted_month_year' do
    context 'when no date is provided' do
      it 'returns current month and year formatted in Portuguese' do
        travel_to Date.new(2025, 6, 10) do
          expect(helper.formatted_month_year).to eq('Junho 2025')
        end
      end
    end

    context 'when a specific date is provided' do
      it 'returns the specific month and year formatted in Portuguese' do
        date = Date.new(2024, 12, 25)
        expect(helper.formatted_month_year(date)).to eq('Dezembro 2024')
      end
    end
  end

  describe '#formatted_date' do
    let(:test_date) { Date.new(2025, 6, 10) }

    context 'when date is blank' do
      it 'returns empty string' do
        expect(helper.formatted_date(nil)).to eq('')
        expect(helper.formatted_date('')).to eq('')
      end
    end

    context 'when date is present' do
      it 'returns formatted date with default format' do
        expect(helper.formatted_date(test_date)).to eq('10/06/2025')
      end

      it 'returns formatted date with custom format' do
        expect(helper.formatted_date(test_date, :long)).to eq('10 de junho de 2025')
      end
    end
  end

  describe '#formatted_datetime' do
    let(:test_datetime) { DateTime.new(2025, 6, 10, 14, 30, 0) }

    context 'when datetime is blank' do
      it 'returns empty string' do
        expect(helper.formatted_datetime(nil)).to eq('')
        expect(helper.formatted_datetime('')).to eq('')
      end
    end

    context 'when datetime is present' do
      it 'returns formatted datetime with default short format' do
        result = helper.formatted_datetime(test_datetime)
        expect(result).to include('10 de junho')
        expect(result).to include('14:30')
      end

      it 'returns formatted datetime with custom format' do
        result = helper.formatted_datetime(test_datetime, :long)
        expect(result).to include('terça-feira')
        expect(result).to include('10 de junho de 2025')
        expect(result).to include('14:30')
      end
    end
  end

  describe '#current_month_name' do
    it 'returns current month name capitalized in Portuguese' do
      travel_to Date.new(2025, 6, 10) do
        expect(helper.current_month_name).to eq('Junho')
      end
    end

    it 'returns correct month name for different months' do
      travel_to Date.new(2025, 1, 15) do
        expect(helper.current_month_name).to eq('Janeiro')
      end

      travel_to Date.new(2025, 12, 25) do
        expect(helper.current_month_name).to eq('Dezembro')
      end
    end
  end

  describe '#current_year' do
    it 'returns current year' do
      travel_to Date.new(2025, 6, 10) do
        expect(helper.current_year).to eq(2025)
      end
    end
  end
end
