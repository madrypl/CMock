require "#{ENV['CMOCK_DIR']}/lib/cmock"

raise "Header file to mock must be specified!" unless ARGV.length >= 1

mock_out = ENV.fetch('MOCK_OUT', './build/test/mocks')
mock_prefix = ENV.fetch('MOCK_PREFIX', 'mock_')
mock_suffix = ENV.fetch('MOCK_SUFFIX', '_mock')
mock_inc_c_pre_header = ENV.fetch('MOCK_INCLUDE_C_PRE_HEADER', nil)
if !mock_inc_c_pre_header.nil?
    mock_inc_c_pre_header = mock_inc_c_pre_header.split(/,/)
end


cmock = CMock.new(plugins: [:ignore, :return_thru_ptr], 
                  mock_prefix: mock_prefix, 
                  mock_suffix: mock_suffix, 
                  mock_path: mock_out,
                  includes_c_pre_header: mock_inc_c_pre_header)
cmock.setup_mocks(ARGV[0])
