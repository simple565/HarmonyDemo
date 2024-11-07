import { preferences } from '@kit.ArkData';

export default class PreferencesUtils {
  private readonly PREFERENCES_NAME: string = 'preferences'
  private static instance: PreferencesUtils
  userPreferences: preferences.Preferences

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
    } catch (err) {
      console.log(`put value to preferences error`)
    }
  }

  get<T extends preferences.ValueType>(key: string, defaultValue: T): T {
    let value: T = defaultValue
    try {
      value = this.userPreferences.getSync(key, defaultValue) as T
    } catch (e) {
      console.log(`get value from preferences error`)
    }
    return value ?? defaultValue
  }
}