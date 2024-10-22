import { Api } from './Api';
import { Response } from './Response';

export interface IRequest {
  request<T>(api: Api): Promise<Response<T>>
}