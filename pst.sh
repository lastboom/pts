#!/bin/bash

# 定义测试套件内容
TEST_SUITE_CONTENT=$(cat <<EOF
<?xml version="1.0"?>
<PhoronixTestSuite>
    <Suite>
        <Title>My Custom Suite</Title>
        <Description>Custom suite for specific tests.</Description>
        <Maintainer>your@email.com</Maintainer>
        <Test>
            <Identifier>pts/blogbench</Identifier>
        </Test>
        <Test>
            <Identifier>pts/fio</Identifier>
        </Test>
        <Test>
            <Identifier>pts/hpcc</Identifier>
        </Test>
        <Test>
            <Identifier>pts/intel-mlc</Identifier>
        </Test>
        <Test>
            <Identifier>pts/java-gradle-perf</Identifier>
        </Test>
        <Test>
            <Identifier>pts/mysqlslap</Identifier>
        </Test>
        <Test>
            <Identifier>pts/nginx</Identifier>
        </Test>
    </Suite>
</PhoronixTestSuite>
EOF
)

# 检测操作系统
if grep -q 'CentOS' /etc/os-release; then
    OS="CentOS"
elif grep -q 'Ubuntu' /etc/os-release; then
    OS="Ubuntu"
else
    echo "此脚本目前仅支持 CentOS 和 Ubuntu。"
    exit 1
fi

# 根据操作系统执行相应的安装步骤
if [ "$OS" == "CentOS" ]; then
    sudo yum update -y
    sudo yum install -y wget php-cli php-xml php-json
elif [ "$OS" == "Ubuntu" ]; then
    sudo apt update -y
    sudo apt install -y wget php-cli php-xml php-json
fi

wget http://phoronix-test-suite.com/releases/phoronix-test-suite-10.0.1.tar.gz
tar -xf phoronix-test-suite-10.0.1.tar.gz
cd phoronix-test-suite/
sudo ./install-sh

# 创建自定义测试套件
echo "$TEST_SUITE_CONTENT" > ~/.phoronix-test-suite/test-suites/custom_suite.xml

# 运行测试
phoronix-test-suite run custom_suite
