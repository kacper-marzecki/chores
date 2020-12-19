import { notification } from "antd";
import { FormInstance, RuleObject } from "antd/lib/form";
import { StoreValue } from "antd/lib/form/interface";
import { NotificationInstance } from "antd/lib/notification";
import Axios, { AxiosResponse } from "axios";
import React from "react";

export function add<T>(arr: T[], elem: T): T[] {
  arr.push(elem);
  return arr;
}

const apiPath = (path: string) => `api/${path}`

export function apiGet<T>(path: string): Promise<T> {
  return Axios.get<T>(apiPath(path), { validateStatus: _ => true })
    .then(extractApiResponse)
}

export function apiDelete<T>(path: string): Promise<T> {
  return Axios.delete<T>(apiPath(path), { validateStatus: _ => true })
    .then(extractApiResponse)
}

export function apiPost<A, B>(path: string, data: A): Promise<B> {
  return Axios.post<B>(apiPath(path), data, { validateStatus: _ => true })
    .then(extractApiResponse)
}

export function extractApiResponse<T>(response: AxiosResponse<T>) {
  const data = response.data;
  switch (response.status) {
    case 422:
    case 401:
    case 403:
    case 400:
      return Promise.reject(data);
    default:
      return Promise.resolve(data);
  }
}

/**
 * AntD string validator 
 */
export const notEmpty = (rule: RuleObject, value: StoreValue, callback: (error?: string) => void) => {

  if ((value as string).trim().length === 0) {
    // TODO internationalize ?
    callback("Cannot be empty")
  }
}

export const formTouchedAndValid = (form: FormInstance) => {
  return !form.isFieldsTouched(false) ||
    form.getFieldsError().filter(({ errors }) => errors.length).length !== 0
}

export function wrapInField<K extends keyof any, T>(fieldName: K): (value: T) => { [P in K]: T } {
  return (value) => {
    let wrapper = {} as { [P in K]: T }
    wrapper[fieldName] = value;
    return wrapper;
  }
}

const openNotification = (type: keyof NotificationInstance, msg: string) => {
  notification[type]({
    duration: 2,
    message: firstToUpper(type),
    description: msg
  });
};

const firstToUpper = (str: string) => str.charAt(0).toUpperCase() + str.slice(1)

type UnionToIntersection<U> =
  (U extends any
    ? (k: U) => void
    : never
  ) extends ((k: infer I) => void) ? I : never

type UpdateFn<T> = {
  [K in keyof T]: (field: K) => (value: T[K]) => void
}[keyof T];

type LazyUpdateFn<T> = {
  [K in keyof T]: (field: K) => (value: T[K]) => () => void
}[keyof T];

export function stateUpdateFn<A>(
  setState: React.Dispatch<React.SetStateAction<A>>
): UnionToIntersection<UpdateFn<A>> {
  const updateFn: UpdateFn<A> = field => value => {
    setState(s => ({
      ...s,
      [field]: value
    }))
  }
  return updateFn as UnionToIntersection<UpdateFn<A>>
}

export function stateUpdateFunctions<A>(
  setState: React.Dispatch<React.SetStateAction<A>>
): [UnionToIntersection<UpdateFn<A>>, UnionToIntersection<LazyUpdateFn<A>>] {
  const eager = stateUpdateFn(setState)
  const lazy: LazyUpdateFn<A> = field => value => () => {
    setState(s => ({
      ...s,
      [field]: value
    }))
  }
  return [eager, lazy as UnionToIntersection<UpdateFn<A>>]
}

export const notifyError = (reason: string) => openNotification('error', reason)

export const notifyInfo = (reason: any) => openNotification('info', prettyPrint(reason))

export const prettyPrint = (it: any) => JSON.stringify(it, null, ' ');
