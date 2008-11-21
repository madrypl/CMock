require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require File.expand_path(File.dirname(__FILE__)) + "/../../lib/cmock_generator_plugin_ignore"

class CMockGeneratorPluginIgnoreTest < Test::Unit::TestCase
  def setup
    create_mocks :config, :utils
    @config.expect.tab.returns("  ")
    @cmock_generator_plugin_ignore = CMockGeneratorPluginIgnore.new(@config, @utils)
  end

  def teardown
  end
  
  should "have set up internal accessors correctly on init" do
    assert_equal(@config, @cmock_generator_plugin_ignore.config)
    assert_equal(@utils,  @cmock_generator_plugin_ignore.utils)
    assert_equal("  ",    @cmock_generator_plugin_ignore.tab)
  end
  
  should "not have no additional include file requirements" do
    assert_equal([], @cmock_generator_plugin_ignore.include_files)
  end
  
  should "add a required variable to the instance structure" do
    function_name = "Grass"
    function_args_as_array = []
    function_return_type = "void"
  
    @config.expect.ignore_bool_type.returns("BOOL")
  
    expected = "  BOOL Grass_IgnoreBool;\n"
    returned = @cmock_generator_plugin_ignore.instance_structure(function_name, function_args_as_array, function_return_type)
    assert_equal(expected, returned)
  end
  
  should "handle function declarations for functions without return values" do
    function_name = "Mold"
    function_args = "void"
    function_return_type = "void"
  
    expected = "void Mold_Ignore(void);\n"
    returned = @cmock_generator_plugin_ignore.mock_function_declarations(function_name, function_args, function_return_type)
    assert_equal(expected, returned)
  end
  
  should "handle function declarations for functions that returns something" do
    function_name = "Fungus"
    function_args = "void"
    function_return_type = "const char*"
  
    expected = "void Fungus_IgnoreAndReturn(const char* toReturn);\n"
    returned = @cmock_generator_plugin_ignore.mock_function_declarations(function_name, function_args, function_return_type)
    assert_equal(expected, returned)
  end
  
  should "add required code to implementation prefix" do
    function_name = "Mold"
    function_args = "void"
    function_return_type = "void"
  
    @utils.expect.make_handle_return(function_name, function_return_type, "    ").returns("    mock_return_1")
    
    expected = ["  if (!Mock.Mold_IgnoreBool)\n",
                "  {\n",
                "    mock_return_1",
                "  }\n"
               ]
    returned = @cmock_generator_plugin_ignore.mock_implementation_prefix(function_name, function_return_type)
    assert_equal(expected, returned)
  end
  
  should "have nothing new for mock implementation" do
    assert_equal([], @cmock_generator_plugin_ignore.mock_implementation("Ooze", []))
  end
  
  should "add a new mock interface for ignoring when function had no return value" do
    function_name = "Slime"
    function_args = "void"
    function_args_as_array = []
    function_return_type = "void"
    
    expected = ["void Slime_Ignore(void)\n",
                "{\n",
                "  Mock.Slime_IgnoreBool = (unsigned char)1;\n",
                "}\n\n"
               ]
    returned = @cmock_generator_plugin_ignore.mock_interfaces(function_name, function_args, function_args_as_array, function_return_type)
    assert_equal(expected, returned)
  end
  
  should "add a new mock interface for ignoring when function has return value" do
    function_name = "Slime"
    function_args = "void"
    function_args_as_array = []
    function_return_type = "uint32"
    
    @utils.expect.make_expand_array("uint32", "Mock.Slime_Return_Head", "toReturn").returns("mock_return_1")
    
    expected = ["void Slime_IgnoreAndReturn(uint32 toReturn)\n",
                "{\n",
                "  Mock.Slime_IgnoreBool = (unsigned char)1;\n",
                "mock_return_1",
                "  Mock.Slime_Return = Mock.Slime_Return_Head;\n",
                "  Mock.Slime_Return += Mock.Slime_CallCount;\n",
                "}\n\n"
               ]
    returned = @cmock_generator_plugin_ignore.mock_interfaces(function_name, function_args, function_args_as_array, function_return_type)
    assert_equal(expected, returned)
  end
  
  should "have nothing new for mock verify" do
    assert_equal([], @cmock_generator_plugin_ignore.mock_verify("Ooze"))
  end
  
  
  should "have nothing new for mock destroy" do
    assert_equal([], @cmock_generator_plugin_ignore.mock_destroy("Ooze", [], "void"))
  end
end