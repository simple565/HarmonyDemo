import { preferences } from '@kit.ArkData';
import { JSON } from '@kit.ArkTS';
import { Log } from './HiLogUtil';
import json from '@ohos.util.json';

export default class PreferencesUtils {
  private readonly TAG = 'PreferencesUtils'
  private readonly PREFERENCES_NAME: string = 'preferences'
  private static instance: PreferencesUtils
  private userPreferences: preferences.Preferences

  private constructor(context: Context) {
    this.userPreferences = preferences.getPreferencesSync(context, {
      name: this.PREFERENCES_NAME
    })
  }

  static getInstance(context: Context): PreferencesUtils {
    if (PreferencesUtils.instance === undefined) {
      PreferencesUtils.instance = new PreferencesUtils(context)
    }
    return PreferencesUtils.instance
  }

  async put(key: string, value: preferences.ValueType) {
    try {
      this.userPreferences.putSync(key, value)
      await this.userPreferences.flush()
      Log.d(this.TAG, `put ${key} value finish`)
    } catch (err) {
      Log.d(this.TAG, `put ${key} value error ${json.stringify(err)}`)
    }
  }

  get<T extends preferences.ValueType>(key: string, defaultValue: T): T {
    let value: T = defaultValue
    try {
      value = this.userPreferences.getSync(key, defaultValue) as T
    } catch (e) {
      Log.d(this.TAG, `get ${key} value error ${JSON.stringify(e)}`)
    }
    return value ?? defaultValue
  }

  delete(key: string) {
    try {
      this.userPreferences.deleteSync(key)
    } catch(err) {
      Log.d(this.TAG, `delete ${key} value error ${JSON.stringify(err)}`)
    }
  }
}