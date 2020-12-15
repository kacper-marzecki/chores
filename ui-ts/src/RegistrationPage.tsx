import { Input, Checkbox, Button, Form, Col, Row } from "antd";
import React from "react";
import { changeLogin, changePage } from "./rootReducer";
import { useApp } from "./store";
import { apiPost, notifyError } from "./utils";
const layout = {
};
export function RegistrationPage() {
    const [store, dispatch] = useApp()
    const onFinish = (values: any) => {
        apiPost('auth/register', values)
            .then(_ => dispatch(changeLogin({ t: "logged", login: values.login })))
            .catch(err => notifyError(`Cannot register in ${err}`))
    };

    const onFinishFailed = (values: any) => {
        console.log('Failed:', values);
    };
    const formItemLayout = {
        labelCol: { span: 4 },
    };
    return (
        <Row style={{ marginTop: 100 }}>
            <Col span={12} offset={6}>
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

                    <Form.Item {...formItemLayout}
                        label="Secret"
                        name="secret"
                        rules={[{ required: true, message: 'required' }]}
                    >
                        <Input.Password />
                    </Form.Item>

                    <Form.Item >
                        <Button type="primary" htmlType="submit" block>
                            Sign up
                            </Button>
                    </Form.Item>
                </Form>
            </Col>
        </Row>

    );
}