import { Input, Checkbox, Button, Form, Col, Row } from "antd";
import React from "react";
import { changeLogin, changePage } from "./rootReducer";
import { useApp } from "./store";
import { apiPost, notifyError } from "./utils";
const layout = {
};
export function Login() {
    const [store, dispatch] = useApp()
    const onFinish = (values: any) => {
        apiPost('auth/login', values)
            .then(_ => dispatch(changeLogin({ t: "logged", login: values.login })))
            .catch(_ => notifyError('Cannot log in'))
    };

    const onFinishFailed = (values: any) => {
        console.log('Failed:', values);
    };
    const formItemLayout = {
        labelCol: { span: 4 },
    };
    return (
        <Row style={{ marginTop: 100 }}>
            <Col span={20} offset={2} md={{span: 10, offset: 7}}  xxl={{span: 6, offset: 9}}>
                <Form
                    {...layout}
                    name="basic"
                    initialValues={{ remember: true }}
                    onFinish={onFinish}
                    onFinishFailed={onFinishFailed}
                >
                    <Form.Item {...formItemLayout}
                        label="Login"
                        name="login"
                        rules={[{ required: true, message: 'Please input your login!' }]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item {...formItemLayout}
                        label="Password"
                        name="password"
                        rules={[{ required: true, message: 'Please input your password!' }]}
                    >
                        <Input.Password />
                    </Form.Item>

                    <Form.Item >
                        <Button type="primary" htmlType="submit" block>
                            Log in
                            </Button>
                    </Form.Item>
                    <Form.Item >
                        <Button type="primary"
                            onClick={() => dispatch(changePage("sign-up"))} block>
                            Sign up
                            </Button>
                    </Form.Item>
                </Form>
            </Col>
        </Row>

    );
}