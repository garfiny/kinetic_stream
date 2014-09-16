require 'spec_helper'

describe KineticStream::Client do
  let(:kinesis_client) { double('kinesis_client') }
  let(:aws_kinesis)    { double('aws_kinesis', client: kinesis_client) }
  let(:stream_name)    { 'any_name' }
  let(:client)         { KineticStream::Client.new }
  let(:limit)          { 10 }

  before do
    allow(AWS::Kinesis).to receive(:new).and_return(aws_kinesis)
  end

  describe '#create_stream' do
    let(:shard_count) { Random.rand(9) + 1 }
    it 'creates new stream by given stream name and shard count' do
      allow(kinesis_client).to receive(:create_stream)
      client.create_stream stream_name, shard_count
      expect(kinesis_client).to have_received(:create_stream).with({
        stream_name: stream_name, shard_count: shard_count
      })
    end
  end

  describe '#delete_stream' do
    it 'deletes the specified stream' do
      allow(kinesis_client).to receive(:delete_stream)
      client.delete_stream stream_name
      expect(kinesis_client).to have_received(:delete_stream).with({stream_name: stream_name})
    end
  end

  describe '#list_stream' do
    it 'lists all streams' do
      allow(kinesis_client).to receive(:list_streams)
      client.list_streams limit
      expect(kinesis_client).to have_received(:list_streams).with(limit: limit)
    end
  end

  describe '#fetch_stream' do
    context 'when it is lazy loading' do
      it 'returns kinetic stream instance' do
        expect(client.fetch_stream stream_name).to be_instance_of KineticStream::Stream
      end
    end
    context 'when it is eager loading' do
      let(:stream) { double('stream', reload!: true) }
      it 'fetches stream and returns kinetic stream instance' do
        allow(KineticStream::Stream).to receive(:new).and_return(stream)
        client.fetch_stream stream_name, false
        expect(stream).to have_received(:reload!)
      end
    end
  end
end
