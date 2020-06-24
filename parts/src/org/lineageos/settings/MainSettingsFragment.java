package org.lineageos.settings;

import android.os.Bundle;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;

public class MainSettingsFragment extends PreferenceFragment {

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.device_settings);
    }

}
