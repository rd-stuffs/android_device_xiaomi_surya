package org.lineageos.settings;

import android.content.Intent;
import android.os.Bundle;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;

import org.lineageos.settings.dirac.DiracActivity;
import org.lineageos.settings.speaker.ClearSpeakerActivity;
import org.lineageos.settings.display.LcdFeaturesPreferenceActivity;
import org.lineageos.settings.refreshrate.RefreshActivity;
import org.lineageos.settings.thermal.ThermalSettingsActivity;

public class MainSettingsFragment extends PreferenceFragment {

    private static final String PREF_DIRAC_SETTINGS = "dirac_settings";
    private static final String PREF_CLEAR_SPEAKER_SETTINGS = "clear_speaker_settings";
    private static final String PREF_LCD_FEATURES_SETTINGS = "lcd_features_settings";
    private static final String PREF_REFRESH_RATE_SETTINGS = "refresh_rate_settings";
    private static final String PREF_THERMAL_SETTINGS = "thermal_settings";

    private Preference mDiracSettingsPref;
    private Preference mClearSpeakerSettingsPref;
    private Preference mLcdFeaturesSettingsPref;
    private Preference mRefreshRateSettingsPref;
    private Preference mThermalSettingsPref;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.xiaomiparts);

        mDiracSettingsPref = (Preference) findPreference(PREF_DIRAC_SETTINGS);
        mDiracSettingsPref.setOnPreferenceClickListener(preference -> {
            Intent intent = new Intent(getActivity().getApplicationContext(), DiracActivity.class);
            startActivity(intent);
            return true;
        });

        mClearSpeakerSettingsPref = (Preference) findPreference(PREF_CLEAR_SPEAKER_SETTINGS);
        mClearSpeakerSettingsPref.setOnPreferenceClickListener(preference -> {
            Intent intent = new Intent(getActivity().getApplicationContext(), ClearSpeakerActivity.class);
            startActivity(intent);
            return true;
        });

        mLcdFeaturesSettingsPref = (Preference) findPreference(PREF_LCD_FEATURES_SETTINGS);
        mLcdFeaturesSettingsPref.setOnPreferenceClickListener(preference -> {
            Intent intent = new Intent(getActivity().getApplicationContext(), LcdFeaturesPreferenceActivity.class);
            startActivity(intent);
            return true;
        });

        mRefreshRateSettingsPref = (Preference) findPreference(PREF_REFRESH_RATE_SETTINGS);
        mRefreshRateSettingsPref.setOnPreferenceClickListener(preference -> {
            Intent intent = new Intent(getActivity().getApplicationContext(), RefreshActivity.class);
            startActivity(intent);
            return true;
        });

        mThermalSettingsPref = (Preference) findPreference(PREF_THERMAL_SETTINGS);
        mThermalSettingsPref.setOnPreferenceClickListener(preference -> {
            Intent intent = new Intent(getActivity().getApplicationContext(), ThermalSettingsActivity.class);
            startActivity(intent);
            return true;
        });

    }

}
